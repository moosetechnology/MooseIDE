"
A MiCriticBrowserCodeQueryTest is a test class for testing the behavior of MiCriticBrowserCodeQuery
"
Class {
	#name : 'MiCBScriptQueryHandlerTest',
	#superclass : 'TestCase',
	#instVars : [
		'handler'
	],
	#category : 'MooseIDE-CriticBrowser-Tests',
	#package : 'MooseIDE-CriticBrowser-Tests'
}

{ #category : 'tests' }
MiCBScriptQueryHandlerTest >> actualClass [

	^ FamixCBScriptQueryHandler
]

{ #category : 'tests' }
MiCBScriptQueryHandlerTest >> setUp [

	handler := self actualClass new
]

{ #category : 'tests' }
MiCBScriptQueryHandlerTest >> testAsRuleEditorString [

	| textQuery |
	textQuery := '[ :entity | entity + 2 ]'.

	handler innerQuery:
		(FQSelectScriptQuery script: textQuery asValuable).

	self assert: handler asRuleEditorString equals: textQuery
]

{ #category : 'tests' }
MiCBScriptQueryHandlerTest >> testConvertToSTONString [

	| textQuery |
	textQuery := '[ :entity | entity + 2 ]'.

	handler innerQuery:
		(FQSelectScriptQuery script: textQuery asValuable).

	self
		assert: handler convertToSTONString
		equals: ('(FQSelectScriptQuery script: {1})' format: { textQuery })
]

{ #category : 'tests' }
MiCBScriptQueryHandlerTest >> testStringAsValuable [

	handler := self actualClass on: '[ :entity | entity odd ]'.
	self assert: (handler innerQuery script value: 1).

	handler := self actualClass on: '#odd'.
	self assert: (handler innerQuery script value: 1)
]
