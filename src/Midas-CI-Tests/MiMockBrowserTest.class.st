Class {
	#name : #MiMockBrowserTest,
	#superclass : #TestCase,
	#category : #'Midas-CI-Tests'
}

{ #category : #tests }
MiMockBrowserTest >> testOpeningBrowser [

	| browser |
	browser := MiMockBrowser on: MiMockBrowser newModel.
	[ browser openWithSpec ] ensure: [ browser owner close ]
]
