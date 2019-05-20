Extension { #name : #Object }

{ #category : #'*GToolkit-Coder' }
Object >> gtCoderFor: aView [
	<gtView>
	^ aView explicit
		title: 'Coder';
		priority: 199;
		stencil: [ (GtClassCoder forObject: self) asElement ]
]

{ #category : #'*GToolkit-Coder' }
Object >> gtMetaFor: aView [
	<gtView>
	^ aView explicit
		title: 'Meta';
		priority: 200;
		stencil: [ (GtClassMethodsCoder forObject: self) asElement ]
]
