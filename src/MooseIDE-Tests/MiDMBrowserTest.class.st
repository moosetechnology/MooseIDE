Class {
	#name : #MiDMBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDMBrowserTest >> browserClass [

	^ MiDMBrowser
]

{ #category : #tests }
MiDMBrowserTest >> testIsConsumerOfFQAbstractQuery [

	self assert:
		((browser application consumersOf: FQAbstractQuery) anySatisfy: [ 
			 :elt | elt = browser settingsPresenter ])
]

{ #category : #tests }
MiDMBrowserTest >> testIsConsumerOfMiDynamicTag [

	self assert:
		((browser application consumersOf: MiDynamicTag) anySatisfy: [ 
			 :elt | elt = browser ])
]

{ #category : #tests }
MiDMBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
