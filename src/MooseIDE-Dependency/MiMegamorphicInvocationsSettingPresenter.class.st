Class {
	#name : #MiMegamorphicInvocationsSettingPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'checkbox',
		'tresholdField',
		'settingCommand',
		'tresholdLabel'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #layout }
MiMegamorphicInvocationsSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: checkbox width: 25;
		  add: tresholdLabel;
		  add: tresholdField;
		  yourself
]

{ #category : #accessing }
MiMegamorphicInvocationsSettingPresenter >> help: aString [

	checkbox help: aString.
	tresholdField help: aString
]

{ #category : #initialization }
MiMegamorphicInvocationsSettingPresenter >> initializePresenters [

	super initializePresenters.
	checkbox := self newCheckBox
		            state: settingCommand currentState;
		            whenChangedDo: [ :state |
				            settingCommand state: state.
				            tresholdLabel visible: state.
				            tresholdField visible: state ].

	tresholdLabel := 'Treshold:' asPresenter
		                 help: 'Number of candidates to be megamorphic';
		                 visible: settingCommand currentState;
		                 yourself.

	tresholdField := self newNumberInput
		                 minimum: 1;
		                 number: settingCommand currentTreshold;
		                 whenNumberChangedDo: [ :number |
			                 settingCommand treshold: number ];
		                 visible: settingCommand currentState
]

{ #category : #'accessing - model' }
MiMegamorphicInvocationsSettingPresenter >> setModelBeforeInitialization: aSettingCommand [

	settingCommand := aSettingCommand
]
