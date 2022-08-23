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

{ #category : #tests }
MiArchitecturalMapBrowserTest >> testSettingsClickOK [
	"overriding to setup the right context"

	browser model entities: #().
	self
		shouldnt: [ 
			browser settings.
			browser model settings buttonOk click ]
		raise: Error.

]
