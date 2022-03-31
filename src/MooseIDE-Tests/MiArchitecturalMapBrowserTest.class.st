Class {
	#name : #MiArchitecturalMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiArchitecturalMapBrowserTest >> browserClass [

	^ MiArchitecturalMapBrowser
]

{ #category : #tests }
MiArchitecturalMapBrowserTest >> testIsConsumerOfFQAbstractQuery [

	self assert:
		((browser application consumersOf: FQAbstractQuery) anySatisfy: [ 
			 :elt | elt = browser settingsPresenter ])
]

{ #category : #tests }
MiArchitecturalMapBrowserTest >> testIsConsumerOfFamixTag [

	self assert:
		((browser application consumersOf: FamixTag) anySatisfy: [ 
			 :elt | elt = browser ])
]

{ #category : #tests }
MiArchitecturalMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
