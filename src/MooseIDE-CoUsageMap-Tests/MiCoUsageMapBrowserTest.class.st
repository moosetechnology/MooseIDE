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
	
	self assert: ((browser application consumersOf: FamixTagAssociation) 
		anySatisfy: [ :each | each = browser coUsageMap ]).
	
	self assert: ((browser application producersOf: FamixTagAssociation)
		anySatisfy: [ :each | each = browser coUsageMap ])
]
