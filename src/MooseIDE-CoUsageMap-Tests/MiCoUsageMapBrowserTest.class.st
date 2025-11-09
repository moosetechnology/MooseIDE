Class {
	#name : 'MiCoUsageMapBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-CoUsageMap-Tests-Browser',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Browser'
}

{ #category : 'running' }
MiCoUsageMapBrowserTest >> browserClass [
	^ MiCoUsageMapBrowser
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> populateBrowser: mooseModel [

	mooseModel add: (FamixStClass new name: 'AClass').
	mooseModel add: (FamixStClass new name: 'AnotherClass').
	browser followEntity: mooseModel entities.

]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> receiveEntityToSelect [

	browser receiveEntity: entityToSelect asMooseGroup
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> settingsApplyButtonPresenter [

	^settingsWindow buttons detect: [ :btn | btn label = 'Apply' ]
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> settingsCloseButtonPresenter [

	^settingsWindow buttons detect: [ :btn | btn label = 'Cancel' ]
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> settingsInnerBoxExtractorListPresenter [

	^settingsWindow presenter
		presenterAt: #lstInnerBoxExtractor
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> settingsResetButtonPresenter [

	^nil
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testBlockSettingsApplyButton [
	"Apply button should close the block setting window"

	settingsWindow := browser openSettings.

	self assert: settingsWindow isOpen.

	self settingsApplyButtonPresenter click.

	self assert: settingsWindow isClosed.

]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testBlockSettingsChangeValue [

	settingsWindow := browser specModel openSettings.

	self settingsInnerBoxExtractorListPresenter selectItem: MiCoChildrenBoxClientClassesExtractor.
	self settingsApplyButtonPresenter  click.
		
	self assert: browser specModel settings innerBoxExtractor equals: MiCoChildrenBoxClientClassesExtractor .

]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testBlockSettingsClickClose [

	self
		assert: browser specModel settings innerBoxExtractor
		equals: browser specModel settings defaultInnerBoxExtractor.

	settingsWindow := browser specModel openSettings.
	self settingsInnerBoxExtractorListPresenter selectItem: MiCoChildrenBoxClientClassesExtractor.

	self settingsCloseButtonPresenter click.

	self assert: browser specModel settings innerBoxExtractor equals: MiCoChildrenBoxAttributeAccessExtractor.

]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testBlockSettingsDefaultValues [

	settingsWindow := browser specModel openSettings.

	self assert: browser specModel settings innerBoxExtractor equals: MiCoChildrenBoxAttributeAccessExtractor.
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testBlockSettingsResetValues [

	self skip: 'reset action removed for now'.

	browser specModel settings innerBoxExtractor: 'Blah'.

	settingsWindow := browser specModel openSettings.

	self
		assert: self settingsInnerBoxExtractorListPresenter text
		equals: 'Blah'.

	self settingsResetButtonPresenter click.

	self
		deny: self settingsInnerBoxExtractorListPresenter text
		equals: 'Blah'.
	self deny: self settingsInnerBoxExtractorListPresenter text isEmpty.

]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testCanOpenSettings [

	browser hasSettings ifFalse: [ ^ self skip ].

	"This should not raise an error"
	settingsWindow := browser openSettings
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testConsumerProducer [
	self assert: ((browser application consumersOf: FamixTag) 
		anySatisfy: [ :each | each = browser mapVisualization ]).
	
	self assert: ((browser application consumersOf: FamixTagAssociation) 
		anySatisfy: [ :each | each = browser mapVisualization ]).
	
	self assert: ((browser application producersOf: FamixTagAssociation)
		anySatisfy: [ :each | each = browser mapVisualization ])
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testSelectedTagSetAndGet [

	| model entity entity2 tag |
	self skip.

	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new
		          name: 'aClass';
		          mooseModel: model;
		          yourself.
	entity2 := FamixRepTestClass new
		           name: 'anotherClass';
		           mooseModel: model;
		           yourself.

	browser followEntity: {
			entity.
			entity2 }.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testSettingsAction [
	"must be redefined in browsers that do have settings"

	self assert: browser hasSettings
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testSettingsClickCancel [
	"skipping for now because settings are handled in a very special way"
	self flag: 'should test settings'.
	self skip.
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testSettingsClickOK [
	"overrind and skipping for now because settings are handled in a very special way"
	self flag: 'should test settings'.
	self skip.
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testSettingsClickReset [
	"overrind and skipping for now because settings are handled in a very special way"
	self flag: 'should test settings'.
	self skip.
]
