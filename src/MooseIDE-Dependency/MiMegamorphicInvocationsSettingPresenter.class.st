Class {
	#name : #MiMegamorphicInvocationsSettingPresenter,
	#superclass : #MiAbstractSettingPresenter,
	#instVars : [
		'checkbox',
		'tresholdField',
		'tresholdLabel',
		'invocationsLabel'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #layout }
MiMegamorphicInvocationsSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  spacing: 5;
		  add: checkbox width: 25;
		  add: tresholdLabel expand: false fill: true;
		  add: tresholdField width: 75;
		  add: invocationsLabel expand: false fill: true;
		  yourself
]

{ #category : #layout }
MiMegamorphicInvocationsSettingPresenter >> fullLayout [

	^ self newBoxLayoutLeftToRight
		  spacing: 5;
		  add: checkbox width: 25;
		  add: tresholdLabel expand: false fill: true;
		  add: tresholdField width: 75;
		  add: invocationsLabel expand: false fill: true;
		  yourself
]

{ #category : #accessing }
MiMegamorphicInvocationsSettingPresenter >> help [

	^ 'Hide invocations if they have more than a specified number of candidates. Examples: #new, #add:'
]

{ #category : #initialization }
MiMegamorphicInvocationsSettingPresenter >> initializePresenters [

	super initializePresenters.
	checkbox := self newCheckBox
		            help: self help;
		            state: configuration hideMegamorphicInvocations;
		            whenChangedDo: [ :state |
				            configuration hideMegamorphicInvocations: state.
				            tresholdLabel visible: state.
				            tresholdField visible: state.
				            invocationsLabel visible: state.
				            self owner layout: self owner layout "Yes, we have to do this, or there will be a computation failure" ].

	tresholdLabel := 'Treshold:' asPresenter
		                 help: 'Number of candidates to be megamorphic';
		                 visible: configuration hideMegamorphicInvocations;
		                 yourself.

	tresholdField := self newNumberInput
		                 help: 'Number of candidates to be megamorphic';
		                 minimum: 1;
		                 number: configuration megamorphicTreshold;
		                 whenNumberChangedDo: [ :number |
			                 configuration megamorphicTreshold: number ];
		                 visible: configuration hideMegamorphicInvocations;
		                 yourself.

	invocationsLabel := self newLabel
		                    label: 'Invocations';
		                    visible: configuration hideMegamorphicInvocations;
		                    yourself
]

{ #category : #accessing }
MiMegamorphicInvocationsSettingPresenter >> label [

	^ 'Hide megamorphic invocations'
]
