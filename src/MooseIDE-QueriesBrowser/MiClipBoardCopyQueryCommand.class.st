Class {
	#name : 'MiClipBoardCopyQueryCommand',
	#superclass : 'MiCommand',
	#category : 'MooseIDE-QueriesBrowser-Commands',
	#package : 'MooseIDE-QueriesBrowser',
	#tag : 'Commands'
}

{ #category : 'default' }
MiClipBoardCopyQueryCommand class >> defaultDescription [

	^ 'Copy query to clipboard'
]

{ #category : 'default' }
MiClipBoardCopyQueryCommand class >> defaultIconName [

	^ #smallCopy
]

{ #category : 'default' }
MiClipBoardCopyQueryCommand class >> defaultName [

	^ 'Copy query to clipboard'
]

{ #category : 'execution' }
MiClipBoardCopyQueryCommand >> execute [

	Clipboard clipboardText: (String streamContents: [ :aStream | self context query storeWithParentsOn: aStream ]) informing: 'Query code copied, use Cmd+V'
]
