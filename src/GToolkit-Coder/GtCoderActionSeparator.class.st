Class {
	#name : #GtCoderActionSeparator,
	#superclass : #GtCoderAction,
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderActionSeparator >> initialize [
	super initialize.
	title := '-------------'.
	action := [ ]
]
