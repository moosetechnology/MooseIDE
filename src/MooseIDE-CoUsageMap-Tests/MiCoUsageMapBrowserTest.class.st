Class {
	#name : #MiCoUsageMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoUsageMapBrowserTest >> browserClass [
	^ MiCoUsageMapBrowser
]

{ #category : #'tests - tags' }
MiCoUsageMapBrowserTest >> testCanTagEntities [
	self flag: 'no tagging for now'.
	self deny: browser canTagEntities
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testConsumerProducer [
	self assert: ((browser application consumersOf: FamixTag) 
		anySatisfy: [ :each | each = browser coUsageMap ]).
	
	self assert: ((browser application consumersOf: FamixTagAssociation) 
		anySatisfy: [ :each | each = browser coUsageMap ]).
	
	self assert: ((browser application producersOf: FamixTagAssociation)
		anySatisfy: [ :each | each = browser coUsageMap ])
]

{ #category : #'tests - tags' }
MiCoUsageMapBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	self skip.
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
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

	self skip.
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testSettingsClickOK [
	"overrind and skipping for now because settings are handled in a very special way"

	self skip.
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testSettingsClickReset [
	"overrind and skipping for now because settings are handled in a very special way"

	self skip.
]
