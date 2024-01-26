Class {
	#name : #MiClipBoardCopyQueryCommand,
	#superclass : #CmCommand,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #default }
MiClipBoardCopyQueryCommand class >> defaultDescription [

	^ 'Copy query to clipboard'
]

{ #category : #default }
MiClipBoardCopyQueryCommand class >> defaultName [

	^ 'Copy query to clipboard'
]

{ #category : #accessing }
MiClipBoardCopyQueryCommand class >> iconName [

	^ #smallCopy
]

{ #category : #execution }
MiClipBoardCopyQueryCommand >> execute [

	Clipboard clipboardText: (String streamContents: [ :aStream | self context query storeWithParentsOn: aStream ]) informing: 'Query code copied, use Cmd+V'
]
