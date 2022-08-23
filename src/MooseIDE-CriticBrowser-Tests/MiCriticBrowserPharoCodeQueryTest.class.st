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
	handler := MiCriticBrowserPharoCodeQuery new.
]

{ #category : #test }
MiCriticBrowserPharoCodeQueryTest >> testConvertToSTONString [
	| query textQuery |
	textQuery := '[ :entity | entity + 2 ]'.
	query := MiCriticBrowserPharoCodeQuery on: textQuery.
	self assert: query convertToSTONString equals: textQuery
]

{ #category : #tests }
MiCriticBrowserPharoCodeQueryTest >> testStringToFullBlockClosure [
	| block |
	block := handler stringToFullBlockClosure: '[ :entity | entity + 2 ]'.
	self assert: (block value: 1) equals: 3 
]
