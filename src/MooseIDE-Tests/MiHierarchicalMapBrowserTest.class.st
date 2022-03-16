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
			 :elt | elt = browser settingsPresenter ])
]

{ #category : #tests }
MiHierarchicalMapBrowserTest >> testIsConsumerOfFamixTag [

	self assert:
		((browser application consumersOf: FamixTag) anySatisfy: [ 
			 :elt | elt = browser ])
]

{ #category : #tests }
MiHierarchicalMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
