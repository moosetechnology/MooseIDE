Class {
	#name : 'MiDSMMemento',
	#superclass : 'MiMemento',
	#instVars : [
		'shouldShowSelfDependencies'
	],
	#category : 'MooseIDE-Dependency-DSM',
	#package : 'MooseIDE-Dependency',
	#tag : 'DSM'
}

{ #category : 'ui' }
MiDSMMemento >> settingsPresenters [

	^ OrderedCollection with: ((MiBooleanSettingPresenter on: self)
			   label: 'Show self dependencies';
			   help:
				   'Show the number of dependencies of an entity on itself on the diagonal of the matrix.';
			   state: shouldShowSelfDependencies;
			   whenStateChangedDo: [ :boolean |
				   self shouldShowSelfDependencies: boolean ];
			   yourself)
]

{ #category : 'accessing' }
MiDSMMemento >> shouldShowSelfDependencies [

	^ shouldShowSelfDependencies
]

{ #category : 'accessing' }
MiDSMMemento >> shouldShowSelfDependencies: anObject [

	shouldShowSelfDependencies := anObject
]
