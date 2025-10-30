"
This is a hack class, to add tool tips to rows in the list of heuristics
Only works for Morphic
"
Class {
	#name : 'MiDeadCodeMorphicStringTableColumn',
	#superclass : 'SpStringTableColumn',
	#category : 'MooseIDE-DeadCode',
	#package : 'MooseIDE-DeadCode'
}

{ #category : 'visiting' }
MiDeadCodeMorphicStringTableColumn >> acceptColumnVisitor: aBuilder [
	"replaces the normal TableCellBuilder by ours that does a special trick"

	| mybuilder |

	mybuilder := MiDeadCodeMorphicTableCellBuilder new.
	mybuilder dataSource: aBuilder dataSource.
	mybuilder cell: aBuilder cell.
	mybuilder rowIndex: aBuilder rowIndex .

	^super acceptColumnVisitor: mybuilder
]
