Class {
	#name : #MiButterflyMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiButterflyMapBrowserTest >> browserClass [

	^ MiButterflyMapBrowser
]

{ #category : #tests }
MiButterflyMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
