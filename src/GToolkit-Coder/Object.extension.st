Extension { #name : #Object }

{ #category : #'*GToolkit-Coder' }
Object >> gtMetaFor: aView [
	<gtView>
	^ aView explicit
		title: 'Meta';
		priority: 200;
		stencil: [ | element |
			self
				flag:
					'TODO this reuses class coder, but depends on its implementation to hide the header, which is not very elegant'.
			element := (GtClassCoder forObject: self) asElement.
			element children first children first visibility: BlVisibility gone.
			element ]
]
