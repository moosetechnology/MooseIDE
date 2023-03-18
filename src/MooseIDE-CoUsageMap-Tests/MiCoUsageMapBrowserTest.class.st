Class {
	#name : #MiCoUsageMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoUsageMapBrowserTest >> browserClass [
	^ MiCoUsageMapBrowser
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

{ #category : #'tests - tags' }
MiCoUsageMapBrowserTest >> testTagSelectedSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser tagSelected: tag.
	self assert: browser tagSelected equals: tag
]
