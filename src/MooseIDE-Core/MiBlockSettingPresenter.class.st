Class {
	#name : 'MiBlockSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'inputField'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiBlockSettingPresenter class >> help [

	^ 'A one-argument Pharo block, e.g. [ :entity | entity numberOfMethods ]'
]

{ #category : 'accessing' }
MiBlockSettingPresenter class >> label [

	^ 'Color block:'
]

{ #category : 'layout' }
MiBlockSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: inputField withConstraints: [ :constraints |
				  constraints
					  expand: true;
					  fill: true;
					  width: 300;
					  height: 80 ];
		  yourself
]

{ #category : 'initialization' }
MiBlockSettingPresenter >> initializePresenters [

	inputField := self newCode
		              text: configuration colorBlockSource;
		              help: self help;
		              whenTextChangedDo: [ :text |
			              configuration colorBlockSource: text ];
		              yourself
]
