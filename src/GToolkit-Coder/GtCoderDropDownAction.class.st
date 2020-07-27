Class {
	#name : #GtCoderDropDownAction,
	#superclass : #GtCoderAction,
	#category : #'GToolkit-Coder'
}

{ #category : #ui }
GtCoderDropDownAction >> buildElementIn: aCoderActionsElement [
	^ aCoderActionsElement newDropButtonForAction: self
]
