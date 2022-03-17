Class {
	#name : #MiCoUsageMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-CoUsageMap-Tests'
}

{ #category : #running }
MiCoUsageMapBrowserTest >> browserClass [
	^ MiCoUsageMapBrowser
]

{ #category : #tests }
MiCoUsageMapBrowserTest >> testConsumerProducer [
	self assert: ((browser application consumersOf: FamixTag) 
		anySatisfy: [ :each | each = browser coUsageMap ]).
		
	self assert: ((browser application producersOf: FamixTag) 
		anySatisfy: [ :each | each = browser coUsageMap ]).
	
	self assert: ((browser application consumersOf: FamixTagAssociation) 
		anySatisfy: [ :each | each = browser coUsageMap ]).
	
	self assert: ((browser application producersOf: FamixTagAssociation)
		anySatisfy: [ :each | each = browser coUsageMap ])
]

{ #category : #'tests - opening' }
MiCoUsageMapBrowserTest >> testSettingsAction [
	"must be redefined in browsers that do have settings"

	| window |
	window := browser settings.
	self assert: (window class inheritsFrom: SystemWindow).
	window close
]
