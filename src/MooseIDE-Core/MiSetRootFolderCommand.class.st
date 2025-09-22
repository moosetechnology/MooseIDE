Class {
	#name : 'MiSetRootFolderCommand',
	#superclass : 'MiModelUtilityCommand',
	#category : 'MooseIDE-Core-Command',
	#package : 'MooseIDE-Core',
	#tag : 'Command'
}

{ #category : 'default' }
MiSetRootFolderCommand class >> defaultIconName [
	^ #glamorousFolder
]

{ #category : 'default' }
MiSetRootFolderCommand class >> defaultName [
	^ 'Set Root Folder'
]

{ #category : 'executing' }
MiSetRootFolderCommand >> execute [

	| dialog file |
	dialog := StOpenDirectoryPresenter new
		          title: 'Choose the root folder for the sources of ' , self model name;
		          openModal;
		          yourself.

	file := dialog cancelled
		        ifTrue: [ nil ]
		        ifFalse: [ dialog selectedEntry ].

	file ifNotNil: [ :folder | self model rootFolder: folder fullName ]
]
