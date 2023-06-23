"
A MiCriticBrowserCodeQueryTest is a test class for testing the behavior of MiCriticBrowserCodeQuery
"
Class {
	#name : #MiCriticBrowserPharoCodeQueryTest,
	#superclass : #TestCase,
	#instVars : [
		'handler'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #tests }
MiCriticBrowserPharoCodeQueryTest >> setUp [ 
	handler := MiCriticBrowserAbstractQuery new.
]

{ #category : #tests }
MiCriticBrowserPharoCodeQueryTest >> testConvertToSTONString [

	| query textQuery |
	textQuery := '[ :entity | entity + 2 ]'.
	query := MiCriticBrowserAbstractQuery on: textQuery.
	self
		assert: query convertToSTONString
		equals: ('(FQSelectScriptQuery script: {1})' format: { textQuery })
]

{ #category : #tests }
MiCriticBrowserPharoCodeQueryTest >> testStringAsValuable [

	handler innerQuery: '[ :entity | entity odd ]'.
	self assert: (handler innerQuery script value: 1).

	handler innerQuery: '#odd'.
	self assert: (handler innerQuery script value: 1)
]
