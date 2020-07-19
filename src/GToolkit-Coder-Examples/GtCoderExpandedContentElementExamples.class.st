Class {
	#name : #GtCoderExpandedContentElementExamples,
	#superclass : #GtCoderContentElementExamples,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #examples }
GtCoderExpandedContentElementExamples >> forMethodCoder [
	<gtExample>
	| aMethodCoder aContentElement |

	aMethodCoder := GtMethodCoder forMethod: (BlElement >> #position:extent:).

	aContentElement := GtSourceCoderExpandedContentElement new coder: aMethodCoder.
	aContentElement look: GtSourceCoderExpandedWithHeaderLook.

	^ aContentElement
]
