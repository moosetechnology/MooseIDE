"
I am a class that has the reponsibility of waiting when an user types someting in a text input field, or a number field.
I wait a certain amount of time before executing the action.
"
Class {
	#name : #InputProcessingWaiter,
	#superclass : #Object,
	#instVars : [
		'process'
	],
	#category : #'MooseIDE-QueriesBrowser-Time delayer'
}

{ #category : #'instance creation' }
InputProcessingWaiter class >> delayBeforeProcessing [

	"Put a delay so the user has time to write a long string or a long number before the spinner appears. Sometimes the user needs to write a long number and for not computing each digit we should wait"

	^ 600 milliSeconds
]

{ #category : #actions }
InputProcessingWaiter >> waitAndRun: aBlock [

	| past |
	past := Time now.
	process ifNotNil: [ process terminate ].
	
	process := [
		self class delayBeforeProcessing wait.
		((self class delayBeforeProcessing + past) <= Time now)
			ifTrue: [ aBlock value ] ] fork
]
