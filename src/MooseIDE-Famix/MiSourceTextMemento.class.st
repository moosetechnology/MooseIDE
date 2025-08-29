Class {
	#name : 'MiSourceTextMemento',
	#superclass : 'MiMemento',
	#instVars : [
		'shouldHighlightChildren'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'ui' }
MiSourceTextMemento >> settingsPresenters [

	^ OrderedCollection with: ((MiBooleanSettingPresenter on: self)
			   label: 'Highlight children?';
			   help: 'Check to highlight the children of the displayed entity';
			   state: shouldHighlightChildren;
			   whenStateChangedDo: [ :state |
				   self shouldHighlightChildren: state ])
]

{ #category : 'accessing' }
MiSourceTextMemento >> shouldHighlightChildren [

	^ shouldHighlightChildren
]

{ #category : 'accessing' }
MiSourceTextMemento >> shouldHighlightChildren: aBoolean [

	shouldHighlightChildren := aBoolean
]
