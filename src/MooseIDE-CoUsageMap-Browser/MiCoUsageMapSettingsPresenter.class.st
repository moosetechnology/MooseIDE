"
todo
"
Class {
	#name : #MiCoUsageMapSettingsPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'childrenTextInput',
		'sortContainerTextInput',
		'sortInnerTextInput'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #specs }
MiCoUsageMapSettingsPresenter class >> defaultSpec [
	^ SpBoxLayout newTopToBottom
		add: 'Children block: ' asPresenter expand: false;
		add: #childrenTextInput;
		add: 'Children sort block: ' asPresenter expand: false;
		add: #sortContainerTextInput;
		add: 'Inner box sort block: ' asPresenter expand: false;
		add: #sortInnerTextInput;
		yourself
]

{ #category : #initialization }
MiCoUsageMapSettingsPresenter >> initializePresenters [
	childrenTextInput := self newCode
		text: '[ :container |
container attributes]';
		yourself.
	sortContainerTextInput := self newCode
		text: '[ :a :b | a < b ]';
		yourself.
	sortInnerTextInput := self newCode
		text: '[:a :b | a < b ]';
		yourself
	
]
