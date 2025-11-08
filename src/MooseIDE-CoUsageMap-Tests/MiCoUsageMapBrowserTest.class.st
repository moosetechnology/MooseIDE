Class {
	#name : 'MiCoUsageMapBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-CoUsageMap-Tests-Browser',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Browser'
}

{ #category : 'running' }
MiCoUsageMapBrowserTest >> blockSettingsPresenter [

	^settingsWindow presenter presenterAt: #blockSettings
]

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

	^self blockSettingsPresenter
		presenterAt: #applyButton
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> settingsChildrenTextInputPresenter [

	^self blockSettingsPresenter
		presenterAt: #childrenTextInput
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> settingsCloseButtonPresenter [

	^self blockSettingsPresenter
		presenterAt: #closeButton
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> settingsResetButtonPresenter [

	^self blockSettingsPresenter
		presenterAt: #resetButton
]

{ #category : 'running' }
MiCoUsageMapBrowserTest >> settingsSortInnerBoxTextInputPresenter [

	^self blockSettingsPresenter
		presenterAt: #sortInnerBoxTextInput
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

	self settingsChildrenTextInputPresenter text: '[ ]'.
	self settingsApplyButtonPresenter  click.
		
	self assert: browser specModel settings childrenBlockText equals: '[ ]'.

]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testBlockSettingsClickClose [

	self
		assert: browser specModel settings childrenBlockText
		equals: browser specModel settings defaultChildrenBlockText.

	settingsWindow := browser specModel openSettings.
	self settingsChildrenTextInputPresenter text: 'Blah'.

	self settingsCloseButtonPresenter click.

	self
		assert: browser specModel settings childrenBlockText
		equals: browser specModel settings defaultChildrenBlockText.

]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testBlockSettingsDefaultValues [

	settingsWindow := browser specModel openSettings.

	self assert: browser specModel settings childrenBlockText isNotEmpty.
]

{ #category : 'tests' }
MiCoUsageMapBrowserTest >> testBlockSettingsResetValues [

	browser specModel settings childrenBlockText: 'Blah'.

	settingsWindow := browser specModel openSettings.

	self
		assert: self settingsChildrenTextInputPresenter text
		equals: 'Blah'.

	self settingsResetButtonPresenter click.

	self
		deny: self settingsChildrenTextInputPresenter text
		equals: 'Blah'.
	self deny: self settingsChildrenTextInputPresenter text isEmpty.

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
