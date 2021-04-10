Class {
	#name : #MiMooseModelBrowserTests,
	#superclass : #MiAbstractBrowserTest,
	#category : #'Midas-Tests-Browsers'
}

{ #category : #accessing }
MiMooseModelBrowserTests class >> defaultTimeLimit [
	self
		flag:
			'This should be removed when opening Moose Model Browser will be faster'.
	^ 1 minute
]

{ #category : #running }
MiMooseModelBrowserTests >> browserClass [
	^ MiMooseModelBrowser
]
