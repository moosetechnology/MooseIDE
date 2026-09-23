Class {
	#name : #MiSourceTextSettingsConfiguration,
	#superclass : #MiAbstractSettingsConfiguration,
	#instVars : [
		'shouldHighlightChildren'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #ui }
MiSourceTextSettingsConfiguration >> settingsPresenters [

	^ OrderedCollection with: ((MiBooleanSettingPresenter on: self)
			   label: 'Highlight children?';
			   help: 'Check to highlight the children of the displayed entity';
			   state: shouldHighlightChildren;
			   whenStateChangedDo: [ :state |
				   self shouldHighlightChildren: state ])
]

{ #category : #accessing }
MiSourceTextSettingsConfiguration >> shouldHighlightChildren [

	^ shouldHighlightChildren
]

{ #category : #accessing }
MiSourceTextSettingsConfiguration >> shouldHighlightChildren: aBoolean [

	shouldHighlightChildren := aBoolean
]
