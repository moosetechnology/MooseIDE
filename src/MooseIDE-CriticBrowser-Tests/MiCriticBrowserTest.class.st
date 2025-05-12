Class {
	#name : #MiCriticBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'stubRule',
		'deadRule',
		'queriesBrowserRule',
		'basicEntity',
		'stubEntity',
		'rootContext',
		'childContext'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #asserting }
MiCriticBrowserTest >> assertFollowActionFor: aMooseObject [

	aMooseObject isCollection 
		ifTrue: [ self assertCollection: browser model entities includesAll: aMooseObject.
					 self assert: browser model entities class equals: aMooseObject class ]
		ifFalse: [ self assert: (browser model entities at: 1) equals: aMooseObject ]
						
]

{ #category : #running }
MiCriticBrowserTest >> browserClass [ 
	^ MiCriticBrowser 
]

{ #category : #tests }
MiCriticBrowserTest >> browserEntitiesListTree [

	^ browser presenterAt: #entitiesList
]

{ #category : #tests }
MiCriticBrowserTest >> browserRulesResultTree [

	^ browser presenterAt: #rulesResult
]

{ #category : #tests }
MiCriticBrowserTest >> browserRulesTree [

	^ browser presenterAt: #rules
]

{ #category : #tests }
MiCriticBrowserTest >> createRulesThenImport [

	| writeStream fileReference readStream |
	browser model
		addChildToRootContext: childContext;
		addChildToRootContext: stubRule;
		addChildToRootContext: queriesBrowserRule.
	browser model addChild: deadRule toContext: childContext.

	fileReference := (FileSystem memory root / 'rules.ston')
		                 asFileReference.
	writeStream := fileReference writeStream.
	browser exportRulesToStream: writeStream.
	writeStream close.

	self removeAllFromRootContext.
	readStream := fileReference readStream.
	browser importRulesFromStream: readStream.
	readStream close
]

{ #category : #running }
MiCriticBrowserTest >> initializeContexts [

	rootContext := browser model rootContext.
	childContext := FamixCBContext
		                named: 'Classes context'
		                on: '[ :col | col allClasses ]'
]

{ #category : #running }
MiCriticBrowserTest >> initializeEntities [

	stubEntity := FamixStMethod named: 'test1'.
	stubEntity isStub: true.

	basicEntity := FamixStMethod named: 'test2'
]

{ #category : #running }
MiCriticBrowserTest >> initializeRules [

	stubRule := FamixCBCondition
		            named: 'test1'
		            on:
		            (FamixCBScriptQueryHandler on:
			             '[ :entity | entity isStub ]').
	deadRule := FamixCBCondition
		            named: 'test2'
		            on:
		            (FamixCBScriptQueryHandler on:
			             '[ :entity | entity isDead ]').
	
	queriesBrowserRule := FamixCBCondition
		                      named: 'test3'
		                      on:
		                      (FamixCBQueryHandler on:
			                       (FQBooleanQuery property: #isDead)).
	queriesBrowserRule query innerQuery parent:
		(FQTypeQuery types: { FamixStMethod })
]

{ #category : #running }
MiCriticBrowserTest >> receiveEntityToSelect [

	super receiveEntityToSelect.
	self browserEntitiesListTree selectPath: { 1 }
]

{ #category : #removing }
MiCriticBrowserTest >> removeAllFromRootContext [

	[ browser model rootContext children isNotEmpty ] whileTrue: [ browser model removeChild: browser model rootContext children anyOne fromContext: browser model rootContext ].
]

{ #category : #running }
MiCriticBrowserTest >> setUp [

	super setUp.

	self initializeRules.
	self initializeContexts.
	self initializeEntities
]

{ #category : #tests }
MiCriticBrowserTest >> testChildrenFor [

	| entity |
	entity := FamixStMethod new.
	entity
		name: 'test';
		isStub: true.
	rootContext addChild: stubRule.
	browser model
		setEntities: entity;
		run.

	browser updateResultList: browser model getAllViolations.
	self
		assert:
		(self browserRulesResultTree roots at: 1) anyOne violatingEntity
		equals: entity
]

{ #category : #tests }
MiCriticBrowserTest >> testChildrenForContext [

	browser model rootContext addChild: stubRule.
	self
		assert: (self browserClass childrenForContext:
				 self browserRulesTree roots anyOne) size
		equals: 1.
	self
		assert: (self browserClass childrenForContext:
				 self browserRulesTree roots anyOne) anyOne
		equals: stubRule
]

{ #category : #tests }
MiCriticBrowserTest >> testDeleteSelectedRule [

	rootContext
		addChild: stubRule;
		addChild: deadRule.
	browser updateRulesList.
	self assert: browser model rootContext children size equals: 2.
	self browserRulesTree selectItem: stubRule.
	browser deleteSelectedRule.
	self assert: browser model rootContext children size equals: 1
]

{ #category : #tests }
MiCriticBrowserTest >> testExportRulesToStream [
	| fileReference writeStream readStream stonReader cont cond1 cond2 cond3 hierarchy |
	
	browser model addChildToRootContext: childContext; addChildToRootContext: stubRule; addChildToRootContext: queriesBrowserRule.
	browser model addChild: deadRule toContext: childContext.
	
	fileReference := (FileSystem memory root / 'rules.ston') asFileReference.
	writeStream := fileReference writeStream.
	browser exportRulesToStream: writeStream.
	writeStream close.
	readStream := fileReference readStream.
	stonReader := STONReader on: fileReference readStream.
	
	cont := stonReader parseObject.
	cond1 := stonReader parseObject.
	cond2 := stonReader parseObject.
	cond3 := stonReader parseObject.
	hierarchy := stonReader parseObject.
	readStream close.
	
	self assert: cont class equals: FamixCBContext.
	self assert: ({ cond1 . cond2 . cond3 } allSatisfy: [ :c | c class = FamixCBCondition ]) equals: true.
	self assert: cond1 query equals: '(FQSelectScriptQuery script: [ :entity | entity isStub ])'.
	self assert: cond2 query equals: '(FQTypeQuery types: {FamixStMethod}) --> (FQBooleanQuery property: #isDead)'.
	self assert: cond3 query equals: '(FQSelectScriptQuery script: [ :entity | entity isDead ])'.
	self assertCollection: hierarchy hasSameElements: { 0. 0. 0. 1 }.
	
	stonReader close
	
]

{ #category : #'tests - actions' }
MiCriticBrowserTest >> testFollowEntity [
	| mooseObjects entity1 entity2 entity3 |
	entity1 := FamixStClass new. entity1 name: 'Test'.
	entity2 := FamixJavaMethod new. entity2 name: 'test'.
	entity3 := FamixStPackage new. entity3 := { entity3 name: 'Test' } asMooseGroup.
	mooseObjects := { entity1. entity2. entity3 } asMooseGroup. 
	
	browser privateReceivingMode: MiFollowMode.
	mooseObjects do: [ :mooseObject | 
		self bus globallySelect: mooseObject.
		self assertFollowActionFor: mooseObject ]
]

{ #category : #tests }
MiCriticBrowserTest >> testImportRulesFromStream [

	self createRulesThenImport.
	self assert: browser model rootContext children size equals: 3
]

{ #category : #tests }
MiCriticBrowserTest >> testImportedRulesAreCorrectlyDisplayed [

	self createRulesThenImport.
	self browserRulesTree clickAtPath: #( 1 1 ).

	self
		assert: browser selectedRule query asRuleEditorString
		equals: '[ :entity | entity isStub ]'
]

{ #category : #tests }
MiCriticBrowserTest >> testMiSelectedItem [

	| entity entityStub |
	entity := FamixStMethod new.
	entityStub := FamixStMethod new.
	entity name: 'test'. entityStub name: 'test'.
	entityStub isStub: true.
	
	"propagating the entity for the model to receive it"
	rootContext addChild: stubRule.
	(browser model) 
		setEntities: {entity. entityStub} asMooseGroup; 
		run.
	browser updateResultList: browser model getAllViolations.
		
	self assert: browser miSelectedItem size equals: 1.
	self assert: (browser miSelectedItem anyOne violatingEntity) equals: entityStub 
]

{ #category : #tests }
MiCriticBrowserTest >> testModelStartsEmpty [

	self assert: (browser model entities isEmpty)
]

{ #category : #tests }
MiCriticBrowserTest >> testMoveCondition [

	| newContext |
	browser model addChild: stubRule toContext: rootContext.
	self assert: rootContext children size equals: 1.
	newContext := FamixCBContext named: 'New context' on: '[ :e | e ]'.
	browser model addChild: newContext toContext: rootContext.
	self assert: rootContext children size equals: 2.
	self browserRulesTree selectItem: stubRule.
	browser moveCurrentRuleComponentToContext: newContext.

	self assert: rootContext children size equals: 1.
	self deny: (rootContext children includes: stubRule).
	self assert: (newContext children includes: stubRule).
	self assert: stubRule parent equals: newContext
]

{ #category : #tests }
MiCriticBrowserTest >> testMoveContext [

	| newContext |
	browser model addChild: childContext toContext: rootContext.
	self assert: rootContext children size equals: 1.
	newContext := FamixCBContext named: 'New context' on: '[ :e | e ]'.
	browser model addChild: newContext toContext: rootContext.
	self assert: rootContext children size equals: 2.
	self browserRulesTree selectItem: childContext.
	browser moveCurrentRuleComponentToContext: newContext.

	self assert: rootContext children size equals: 1.
	self deny: (rootContext children includes: childContext).
	self assert: (newContext children includes: childContext).
	self assert: childContext parent equals: newContext
]

{ #category : #tests }
MiCriticBrowserTest >> testRunButtonAction [

	browser model setEntities: { stubEntity } asMooseGroup.
	rootContext addChild: stubRule.

	"runButtonAction without fork and updates"
	browser model run.

	self assert: browser model violations size equals: 1
]

{ #category : #tests }
MiCriticBrowserTest >> testSelectedRules [

	| classEntity methodsContext |
	classEntity := FamixJavaClass named: 'Test'.
	methodsContext := FamixCBContext
		                  named: 'Methods'
		                  on: '[ :col | col allMethods ]'.
	browser model setEntities: {
			stubEntity.
			basicEntity.
			classEntity } asMooseGroup.
	browser model addChild: stubRule toContext: rootContext.
	browser model addChild: methodsContext toContext: rootContext.
	browser model addChild: deadRule toContext: methodsContext.
	browser model run.
	browser updateRulesList.
	browser updateResultList: browser model getAllViolations.
	self browserRulesTree selectItem: stubRule.
	self assert: self browserRulesResultTree roots flatten size equals: 1.
	self
		assert:
		self browserRulesResultTree roots flatten anyOne violatingEntity
		equals: stubEntity.
	self
		assertCollection: self browserEntitiesListTree roots flatten
		hasSameElements: {
				stubEntity.
				basicEntity.
				classEntity }.
	self browserRulesTree unselectItem: stubRule.
	self browserRulesTree selectItem: deadRule.
	self assert: self browserRulesResultTree roots flatten size equals: 2.
	self
		assertCollection:
			self browserRulesResultTree roots flatten asMooseGroup specialize
				allEntities
		hasSameElements: {
				stubEntity.
				basicEntity }.
	self
		assertCollection: self browserEntitiesListTree roots flatten
		hasSameElements: {
				stubEntity.
				basicEntity }
]

{ #category : #'tests - tags' }
MiCriticBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]

{ #category : #tests }
MiCriticBrowserTest >> testUnselectPrintsCompleteOutput [

	browser model setEntities: {
			stubEntity.
			basicEntity } asMooseGroup.
	rootContext
		addChild: stubRule;
		addChild: deadRule.

	"runButtonAction without fork and updates"
	browser model run.
	self browserRulesTree selectItem: stubRule.
	self browserRulesTree unselectAll.
	self assert: self browserRulesResultTree roots flatten size equals: 3
]

{ #category : #tests }
MiCriticBrowserTest >> testUpdateEntitiesList [

	browser model setEntities: stubEntity.
	browser updateEntitiesList: browser model entities.
	self
		assert: self browserEntitiesListTree roots flatten size
		equals: 1
]

{ #category : #tests }
MiCriticBrowserTest >> testUpdateResultList [

	browser updateResultList:
		{ (FamixCBViolation condition: stubRule violatedBy: stubEntity) }
			asMooseSpecializedGroup.
	self assert: self browserRulesResultTree roots flatten size equals: 1.

	browser updateResultList: FamixCBViolationGroup new.
	self assert: self browserRulesResultTree roots flatten size equals: 0
]
