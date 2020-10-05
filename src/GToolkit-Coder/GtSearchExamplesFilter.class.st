Class {
	#name : #GtSearchExamplesFilter,
	#superclass : #GtSearchPragmasFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchExamplesFilter class >> filterDescriptorFor: aMethodsCoder [
	^ (GtFilterDescriptor
		creator: [ :value | self new ]
		named: 'Examples'
		order: 12)
		valueNotRequired
]

{ #category : #initialization }
GtSearchExamplesFilter >> initialize [
	super initialize.
	symbol := #gtExample.
]
