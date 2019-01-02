Class {
	#name : #GtCoderCommentStyler,
	#superclass : #GtCoderBodyStyler,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderCommentStyler >> visitNode: aNode [
	| source comments |
	comments := aNode comments.
	comments notEmpty
		ifTrue: [ source := aNode source.
			comments
				do: [ :each | 
					| comment document |
					"Hack to make sure we have the same indices for the part we are formatting"
					comment := ((String new: each start withAll: Character cr) , each contents) asRopedText.
					(text from: each start + 1 to: each start + comment size)
						attributes: {(GtCompletionStrategyAttribute new strategy: Gt2DocumentCompletionStrategy new)}.
					document := Gt2Document new.
					document text: comment.
					comment := document defaultStyler styledTextFor: comment unstyle.
					each start + 1 to: each start + comment size do: [ :i | (text from: i to: i) attributes: (comment attributesAt: i) ] ] ].
	^ super visitNode: aNode
]
