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
MiCoUsageMapBrowserTest >> testCanOpenSettings [

	browser hasSettings ifFalse: [ self skip ].
	"this should not raise an error"
	browser settings.
  "tear down"
	[ browser closeSettings ]
		on: Error
		do: [ "nothing -- ensuring settings window is closed" ]
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
