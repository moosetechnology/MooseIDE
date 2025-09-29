Class {
	#name : #MiCoUsageMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoUsageMapBrowserTest >> browserClass [
	^ MiCoUsageMapBrowser
]

{ #category : #'tests - actions' }
MiCoUsageMapBrowserTest >> populateBrowser: mooseModel [

	mooseModel add: (FamixStClass new name: 'AClass').
	mooseModel add: (FamixStClass new name: 'AnotherClass').
	browser followEntity: mooseModel entities.

]

{ #category : #running }
MiCoUsageMapBrowserTest >> receiveEntityToSelect [

	browser receiveEntity: entityToSelect asMooseGroup
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testBlockSettingsApplyButton [
	"Apply button should close the block setting window"

	| settings |

	settings := MiCoUsageMapBlockSettingsPresenter new 
		settings: MiCoUsageMapSettings ;
		open ;
		yourself.

	self assert: settings owner isOpen.

	settings applyButton click.

	self assert: settings owner isClosed.

]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testBlockSettingsChangeValue [

	| settings |

	settings := MiCoUsageMapBlockSettingsPresenter new 
		settings: MiCoUsageMapSettings ;
		yourself.

	[
		settings sortInnerBoxTextInput text: '[ ]'.
		settings applyButton click.
		
		self assert: MiCoUsageMapSettings innerBoxSortBlockText equals: '[ ]'.
	]
	ensure: [
		"tearDown"
		settings delete ]
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testBlockSettingsClickClose [

	| settings |

	self
		assert: MiCoUsageMapSettings childrenBlockText
		equals: MiCoUsageMapSettings defaultChildrenBlockText.

	settings := MiCoUsageMapBlockSettingsPresenter new 
		settings: MiCoUsageMapSettings ;
		yourself.
	settings childrenTextInput text: 'Blah'.
	
	[
		settings closeButton click.

		self
			assert: MiCoUsageMapSettings childrenBlockText
			equals: MiCoUsageMapSettings defaultChildrenBlockText.
	]
	ensure: [
		"tearDown"
		settings delete ]
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testBlockSettingsDefaultValues [

	| settings |
	settings := MiCoUsageMapBlockSettingsPresenter new 
		settings: MiCoUsageMapSettings ;
		yourself.

	[
		self assert: settings childrenTextInput     text isNotEmpty.
		self assert: settings sortInnerBoxTextInput text isNotEmpty.
		self assert: settings sortOuterBoxTextInput text isNotEmpty.
	]
	ensure: [
		"tearDown"
		settings delete ]
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testBlockSettingsResetValues [

	| settings |
	MiCoUsageMapSettings childrenBlockText: 'Blah'.
	self assert: MiCoUsageMapSettings childrenBlockText equals: 'Blah'.

	settings := MiCoUsageMapBlockSettingsPresenter new 
		settings: MiCoUsageMapSettings ;
		yourself.

	[
		settings resetButton click.

		self deny: MiCoUsageMapSettings childrenBlockText equals: 'Blah'.
		self deny: MiCoUsageMapSettings childrenBlockText isEmpty.
	]
	ensure: [
		"tearDown"
		settings delete ]
]

{ #category : #'tests - settings' }
MiCoUsageMapBrowserTest >> testCanOpenSettings [

	browser hasSettings ifFalse: [ ^ self skip ].

	"This should not raise an error"
	settingsWindow := browser openSettings
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testConsumerProducer [
	self assert: ((browser application consumersOf: FamixTag) 
		anySatisfy: [ :each | each = browser mapVisualization ]).
	
	self assert: ((browser application consumersOf: FamixTagAssociation) 
		anySatisfy: [ :each | each = browser mapVisualization ]).
	
	self assert: ((browser application producersOf: FamixTagAssociation)
		anySatisfy: [ :each | each = browser mapVisualization ])
]

{ #category : #'tests - tags' }
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

{ #category : #tests }
MiCoUsageMapBrowserTest >> testSettingsAction [
	"must be redefined in browsers that do have settings"

	self assert: browser hasSettings
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testSettingsClickCancel [
	"skipping for now because settings are handled in a very special way"
	self flag: 'should test settings'.
	self skip.
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testSettingsClickOK [
	"overrind and skipping for now because settings are handled in a very special way"
	self flag: 'should test settings'.
	self skip.
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testSettingsClickReset [
	"overrind and skipping for now because settings are handled in a very special way"
	self flag: 'should test settings'.
	self skip.
]
