Class {
	#name : #MiAbstractCriticBrowserCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #converting }
MiAbstractCriticBrowserCommand class >> asCommandGroupWith: aPresenter [

	| exportCommandGroup |
	exportCommandGroup := CmCommandGroup forSpec beRoot.
	(self allSubclasses sort: #priority ascending) do: [ :cmd | 
		exportCommandGroup register: (cmd forSpecContext: aPresenter) ].
	^ exportCommandGroup
]

{ #category : #'accessing - defaults' }
MiAbstractCriticBrowserCommand class >> defaultDescription [

	^ 'Possible actions for contexts and conditions'
]

{ #category : #'accessing - defaults' }
MiAbstractCriticBrowserCommand class >> defaultName [

	^ 'Rules menu'
]

{ #category : #accessing }
MiAbstractCriticBrowserCommand class >> priority [

	^ self subclassResponsibility
]
