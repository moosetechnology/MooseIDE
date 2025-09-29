Class {
	#name : #MiDSMSettingsConfiguration,
	#superclass : #MiAbstractSettingsConfiguration,
	#instVars : [
		'shouldShowSelfDependencies'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #ui }
MiDSMSettingsConfiguration >> settingsPresenters [

	^ OrderedCollection with: ((MiBooleanSettingPresenter on: self)
			   label: 'Show self dependencies';
			   help:
				   'Show the number of dependencies of an entity on itself on the diagonal of the matrix.';
			   state: shouldShowSelfDependencies;
			   whenStateChangedDo: [ :boolean |
				   self shouldShowSelfDependencies: boolean ];
			   yourself)
]

{ #category : #accessing }
MiDSMSettingsConfiguration >> shouldShowSelfDependencies [

	^ shouldShowSelfDependencies
]

{ #category : #accessing }
MiDSMSettingsConfiguration >> shouldShowSelfDependencies: anObject [

	shouldShowSelfDependencies := anObject
]
