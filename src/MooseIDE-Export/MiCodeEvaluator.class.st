"
I am a microdown code evaluator. I execute a block when the parameter eval is set as true.
I am a basic microdown visitor, the only thing I do is to execute the code in a context, using MiCodeEvaluatorEnv.
"
Class {
	#name : #MiCodeEvaluator,
	#superclass : #MicCodeblockEvaluator,
	#instVars : [
		'model',
		'evaluatorEnv'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #visiting }
MiCodeEvaluator >> evaluate: aCodeBlock [

	| content |
	content := self evaluationStringFor: aCodeBlock.
	^ [ (Microdown parse: content) children ]
		on: Error
		do: [ :e | MicBoldFormatBlock new children: { (MicTextBlock new substring: e messageText) } ]
]

{ #category : #visiting }
MiCodeEvaluator >> evaluationStringFor: aCodeBlock [

	^ String
		streamContents: [ :stream | 
			evaluatorEnv stream: stream.
			[ self class compiler
				source: aCodeBlock body;
				logged: false;
				bindings: evaluatorEnv globals;
				receiver: evaluatorEnv;
				evaluate ]
				on: Error
				do: [ :e | 
					stream
						nextPutAll: e description ] ]
]

{ #category : #initialization }
MiCodeEvaluator >> initialize [

	super initialize.
	evaluatorEnv := MiCodeEvaluatorEnv new.
]

{ #category : #accessing }
MiCodeEvaluator >> model [

	^ model
]

{ #category : #accessing }
MiCodeEvaluator >> model: anObject [

	model := anObject.
	evaluatorEnv entities: model
]

{ #category : #visiting }
MiCodeEvaluator >> visitCode: aCodeBlock [

	aCodeBlock isEvaluated = 'true' ifTrue: [ 
		self replaceCurrentNodeBy: (self evaluate: aCodeBlock) ] 
]
