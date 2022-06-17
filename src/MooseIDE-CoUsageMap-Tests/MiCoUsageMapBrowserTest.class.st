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

	self assert:
		((browser application consumersOf: FamixTag) anySatisfy: [ :each | 
			 each = browser containedBrowser coUsageMap ]).

	self assert:
		((browser application consumersOf: FamixTagAssociation) anySatisfy: [ 
			 :each | each = browser containedBrowser coUsageMap ]).

	self assert:
		((browser application producersOf: FamixTagAssociation) anySatisfy: [ 
			 :each | each = browser containedBrowser coUsageMap ])
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testSettingsAction [
	"must be redefined in browsers that do have settings"

	self assert: browser hasSettings
]
