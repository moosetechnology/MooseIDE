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
MiDMBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
