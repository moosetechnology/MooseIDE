Class {
	#name : #MiSystemComplexityBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiSystemComplexityBrowserTest >> browserClass [

	^ MiSystemComplexityBrowser
]

{ #category : #tests }
MiSystemComplexityBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
