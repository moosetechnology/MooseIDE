Class {
	#name : 'MiMegamorphicInvocationsSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'checkbox',
		'tresholdField',
		'tresholdLabel',
		'invocationsLabel'
	],
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
}

{ #category : 'layout' }
MiMegamorphicInvocationsSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  spacing: 5;
		  add: checkbox width: 25;
		  add: tresholdLabel expand: false fill: true;
		  add: tresholdField width: 75;
		  add: invocationsLabel expand: false fill: true;
		  yourself
]

{ #category : 'layout' }
MiMegamorphicInvocationsSettingPresenter >> fullLayout [

	^ self newBoxLayoutLeftToRight
		  spacing: 5;
		  add: checkbox width: 25;
		  add: tresholdLabel expand: false fill: true;
		  add: tresholdField width: 75;
		  add: invocationsLabel expand: false fill: true;
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
				            tresholdField visible: state.
				            invocationsLabel visible: state.
				            self owner layout: self owner layout "Yes, we have to do this, or there will be a computation failure" ].

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
		                 visible: memento hideMegamorphicInvocations;
		                 yourself.

	invocationsLabel := self newLabel
		                    label: 'Invocations';
		                    visible: memento hideMegamorphicInvocations;
		                    yourself
]

{ #category : 'accessing' }
MiMegamorphicInvocationsSettingPresenter >> label [

	^ 'Hide megamorphic invocations'
]
