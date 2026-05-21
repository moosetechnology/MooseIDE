Class {
	#name : 'MiDeadAbstractCustomRule',
	#superclass : 'MiDeadAbstractRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadAbstractCustomRule >> name [

	^super name , 'Custom rule: '
]

{ #category : 'actions' }
MiDeadAbstractCustomRule >> whenChosen [
	"Should return a 'configured' copy of the rule
	 This allows to dynamically change the name of the chosen rule while
	 leaving the proposed rule untouched"

	| instance |
	instance := self copy.
	(MiSettingsPresenter on: instance) openDialog.
	^instance
]
