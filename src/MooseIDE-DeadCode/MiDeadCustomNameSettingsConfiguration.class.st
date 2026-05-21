Class {
	#name : 'MiDeadCustomNameSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'ruleIdentifier',
		'nameRegex',
		'refuteDead'
	],
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadCustomNameSettingsConfiguration >> nameRegex [

	^ nameRegex
]

{ #category : 'accessing' }
MiDeadCustomNameSettingsConfiguration >> nameRegex: anObject [

	nameRegex := anObject
]

{ #category : 'accessing' }
MiDeadCustomNameSettingsConfiguration >> refuteDead [

	^ refuteDead
]

{ #category : 'accessing' }
MiDeadCustomNameSettingsConfiguration >> refuteDead: anObject [

	refuteDead := anObject
]

{ #category : 'accessing' }
MiDeadCustomNameSettingsConfiguration >> ruleIdentifier [

	^ ruleIdentifier
]

{ #category : 'accessing' }
MiDeadCustomNameSettingsConfiguration >> ruleIdentifier: anObject [

	ruleIdentifier := anObject
]

{ #category : 'ui' }
MiDeadCustomNameSettingsConfiguration >> settingsPresenters [

	^ super settingsPresenters

		add: ((MiTextFieldSettingPresenter on: self)
			label: 'Rule name';
		   help: 'A name to identify this rule in the browser';
			text: self ruleIdentifier ;
			whenTextChangedDo: [ :name | self ruleIdentifier: name ];
			yourself);

		add: ((MiTextFieldSettingPresenter on: self)
			label: 'Name regexp';
		   help: 'A regular expression that the method name must match';
			text: self nameRegex ;
			whenTextChangedDo: [ :regexp | self nameRegex: regexp ];
			yourself);

		add: ((MiBooleanSettingPresenter on: self)
			label: 'Refute method is dead';
		   help: 'If true, this rules "forces" the entity to not-dead';
			state: refuteDead ;
			whenStateChangedDo: [ :boolean | self refuteDead: boolean ];
			yourself);

		  yourself
]
