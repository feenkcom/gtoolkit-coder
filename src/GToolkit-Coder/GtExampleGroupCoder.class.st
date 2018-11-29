Class {
	#name : #GtExampleGroupCoder,
	#superclass : #GtMethodsCoder,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtExampleGroupCoder class >> forExampleGroup: anExampleGroup [

	^ self new forExampleGroup: anExampleGroup

]

{ #category : #'instance creation' }
GtExampleGroupCoder >> forExampleGroup: anExampleGroup [
	methodCoders := anExampleGroup collect: [ :each | GtMethodCoder forExample: each ]
]
