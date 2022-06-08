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
MiArchitecturalMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
