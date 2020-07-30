Class {
	#name : #GtFilterTaggerTag,
	#superclass : #BrTaggerTag,
	#instVars : [
		'tagType'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #accessing }
GtFilterTaggerTag >> tagType [
	^ tagType
]

{ #category : #accessing }
GtFilterTaggerTag >> tagType: aString [
	tagType := aString
]
