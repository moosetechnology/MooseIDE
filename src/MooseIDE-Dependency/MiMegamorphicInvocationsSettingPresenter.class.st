Class {
	#name : 'MiMegamorphicInvocationsSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'checkbox',
		'tresholdField',
		'tresholdLabel'
	],
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
}

{ #category : 'layout' }
MiMegamorphicInvocationsSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: checkbox width: 25;
		  add: tresholdLabel;
		  add: tresholdField;
		  yourself
]

{ #category : 'accessing' }
MiMegamorphicInvocationsSettingPresenter >> help [

	^ 'Hide invocations if they have more than a specified number of candidates. Examples: #new, #add:'
]

{ #category : 'initialization' }
MiMegamorphicInvocationsSettingPresenter >> initializePresenters [

	super initializePresenters.
	checkbox := self newCheckBox
		            help: self help;
		            state: memento hideMegamorphicInvocations;
		            whenChangedDo: [ :state |
				            memento hideMegamorphicInvocations: state.
				            tresholdLabel visible: state.
				            tresholdField visible: state ].

	tresholdLabel := 'Treshold:' asPresenter
		                 help: 'Number of candidates to be megamorphic';
		                 visible: memento hideMegamorphicInvocations;
		                 yourself.

	tresholdField := self newNumberInput
		                 help: 'Number of candidates to be megamorphic';
		                 minimum: 1;
		                 number: memento megamorphicTreshold;
		                 whenNumberChangedDo: [ :number |
			                 memento megamorphicTreshold: number ];
		                 visible: memento hideMegamorphicInvocations
]

{ #category : 'accessing' }
MiMegamorphicInvocationsSettingPresenter >> label [

	^ 'Hide megamorphic invocations'
]
