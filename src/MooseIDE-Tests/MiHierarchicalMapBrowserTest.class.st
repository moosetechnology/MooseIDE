Class {
	#name : #MiHierarchicalMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiHierarchicalMapBrowserTest >> browserClass [

	^ MiHierarchicalMapBrowser
]

{ #category : #tests }
MiHierarchicalMapBrowserTest >> testIsConsumerOfFQAbstractQuery [

	self assert:
		((browser application consumersOf: FQAbstractQuery) anySatisfy: [ 
			 :elt | elt = browser settings ])
]

{ #category : #tests }
MiHierarchicalMapBrowserTest >> testIsConsumerOfMiDynamicTag [

	self assert:
		((browser application consumersOf: MiDynamicTag) anySatisfy: [ 
			 :elt | elt = browser ])
]
