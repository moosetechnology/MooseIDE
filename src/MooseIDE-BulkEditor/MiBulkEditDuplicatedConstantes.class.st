Class {
	#name : 'MiBulkEditDuplicatedConstantes',
	#superclass : 'MiBulkEditorAbstract',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'utilities' }
MiBulkEditDuplicatedConstantes >> groupByFile: data [
	"First change structure of data
		from: 'constant-literal -> { collection-of-entities }'
	 	to: 'entity -> { collection-of-synonym-entities }'
	 Then group by source file"

	^((self restructureData: data)
		reject: [:asso | asso key sourceAnchor isNil ])
		groupedBy: [ :asso | asso key sourceAnchor fileName ]
]

{ #category : 'initialization' }
MiBulkEditDuplicatedConstantes >> initialize [ 

	super initialize.

	rewriter := MiBulkEndLineCommentRewriter 
]

{ #category : 'running' }
MiBulkEditDuplicatedConstantes >> mooseModel: data [

	^super mooseModel: data anyOne value
]

{ #category : 'utilities' }
MiBulkEditDuplicatedConstantes >> restructureData: data [
	"change structure of data
		from: 'constant-literal -> { collection-of-entities }'
	 	to: 'entity -> { collection-of-synonym-entities }'"

	^data flatCollect: [ :cstAssoc |
		cstAssoc value collect: [ :entity |
			entity -> (cstAssoc value reject: [:synonym | synonym = entity]) ]
	]
]
