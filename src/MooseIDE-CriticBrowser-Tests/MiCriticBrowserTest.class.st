Class {
	#name : #MiCriticBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'stubRule',
		'deadRule',
		'queriesBrowserRule',
		'basicEntity',
		'stubEntity',
		'rootContext'
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

{ #category : #running }
MiCriticBrowserTest >> setUp [
	super setUp.
	stubRule := FamixCBCondition named: 'test1' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	deadRule := FamixCBCondition named: 'test2' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isDead ]')).
	queriesBrowserRule := FamixCBCondition named: 'test3' on: (MiCriticBrowserFQQuery on: (FQBooleanQuery property: #isDead)).
	queriesBrowserRule query query parent: (FQTypeQuery types: { FamixStMethod } ).
	
	stubEntity := FamixStMethod new.
	stubEntity name: 'test1'; isStub: true.
	basicEntity := FamixStMethod new.
	basicEntity name: 'test2'.
	
	rootContext := browser model rootContext.
]

{ #category : #test }
MiCriticBrowserTest >> testChildrenFor [
	| entity |
	entity := FamixStMethod new.
	entity name: 'test'; isStub: true.
	rootContext addChild: stubRule.
	browser model 
		setEntities: entity;
		run.
	
	browser updateResultList: browser model getAllViolations.
	self assert: (browser children: (browser rulesResult roots anyOne) for: (browser rulesResult)) anyOne violatingEntity equals: entity
]

{ #category : #tests }
MiCriticBrowserTest >> testChildrenForContext [
	browser model rootContext addChild: stubRule.
	self assert: (browser childrenForContext: browser rules roots anyOne) size equals: 1.
	self assert: (browser childrenForContext: browser rules roots anyOne) anyOne equals: stubRule
]

{ #category : #test }
MiCriticBrowserTest >> testDeleteSelectedRule [
	rootContext addChild: stubRule; addChild: deadRule.
	browser updateRulesList.
	self assert: browser model rootContext children size equals: 2.
	browser rules selectItem: stubRule.
	browser deleteSelectedRule.
	self assert: browser model rootContext children size equals: 1
]

{ #category : #test }
MiCriticBrowserTest >> testExportRulesToStream [
	| fileReference writeStream readStream stonReader rule1 rule2 rule3 |
	browser model addRule: deadRule; addRule: stubRule; addRule: queriesBrowserRule.
	fileReference := (FileSystem memory root / 'rules.ston') asFileReference.
	writeStream := fileReference writeStream.
	browser exportRules: (browser model rules) toStream: writeStream.
	writeStream close.
	
	readStream := fileReference readStream.
	stonReader := STONReader on: fileReference readStream.
	rule1 := stonReader parseObject.
	rule2 := stonReader parseObject.
	rule3 := stonReader parseObject.
	readStream close.
	self assert: rule1 class equals: FamixCBRule.
	self assert: rule1 query equals: '[ :entity | entity isDead ]'.
	self assert: rule2 query equals: '[ :entity | entity isStub ]'.
	self assert: rule3 query equals: '(FQTypeQuery types: {FamixStMethod}) --> (FQBooleanQuery property: #isDead)'.
	stonReader close
	
]

{ #category : #test }
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

{ #category : #test }
MiCriticBrowserTest >> testImportRulesFromStream [
	| fileReference writeStream readStream |
	browser model addRule: deadRule; addRule: stubRule; addRule: queriesBrowserRule.
	browser model setEntities: { stubEntity. basicEntity } asMooseGroup.
	fileReference := (FileSystem memory root / 'rules.ston') asFileReference.
	writeStream := fileReference writeStream.
	browser exportRules: (browser model rules) toStream: writeStream.
	writeStream close.
	
	browser model rules removeAll.
	readStream := fileReference readStream.
	browser importRulesFromStream: readStream.
	readStream close.
	self assertCollection: ((browser model rules at: 1) runOn: browser model entities) allEntities includesAll: { basicEntity. stubEntity }.
	self assertCollection: ((browser model rules at: 2) runOn: browser model entities) allEntities includesAll: { stubEntity }.
	self assertCollection: ((browser model rules at: 3) runOn: browser model entities) allEntities includesAll: { stubEntity }.

]

{ #category : #test }
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

{ #category : #test }
MiCriticBrowserTest >> testRunButtonAction [
	browser model setEntities: { stubEntity } asMooseGroup.
	rootContext addChild: stubRule.
	browser runButton performAction.
	
	self assert: browser model violations size equals: 1
	
]

{ #category : #test }
MiCriticBrowserTest >> testSelectedRules [
	browser model setEntities: { stubEntity. basicEntity } asMooseGroup.
	rootContext addChild: stubRule; addChild: deadRule.
	browser model run.
	browser updateRulesList.
	browser updateResultList: browser model getAllViolations.
	
	browser rules selectItem: stubRule.
	self assert: browser rulesResult roots flatten size equals: 1.
	self assert: browser rulesResult roots flatten anyOne violatingEntity equals: stubEntity.
	
	browser rules unselectItem: stubRule.
	browser rules selectItem: deadRule.
	self assert: browser rulesResult roots flatten size equals: 2.
	self assertCollection: browser rulesResult roots flatten asMooseGroup specialize allEntities includesAll: { stubEntity. basicEntity }.
	
]

{ #category : #tests }
MiCriticBrowserTest >> testUnselectPrintsCompleteOutput [
	browser model setEntities: { stubEntity. basicEntity } asMooseGroup.
	rootContext addChild: stubRule; addChild: deadRule.
	browser runButtonAction.
	
	browser rules selectItem: stubRule.
	browser rules unselectAll.
	self assert: (browser rulesResult roots flatten size) equals: 3

]

{ #category : #test }
MiCriticBrowserTest >> testUpdateEntitiesList [
	browser model setEntities: stubEntity.
	browser updateEntitiesList.
	self assert: (browser entitiesList roots flatten size) equals: 1
]

{ #category : #test }
MiCriticBrowserTest >> testUpdateResultList [
	browser updateResultList: { FamixCBViolation condition: stubRule violatedBy: stubEntity } asMooseGroup specialize.
	self assert: (browser rulesResult roots flatten size) equals: 1.
	
	browser updateResultList: FamixCBViolationGroup new.
	self assert: (browser rulesResult roots flatten size) equals: 0
]
