const PDFDocument = require('pdfkit');
const fs = require('fs');

const doc = new PDFDocument({ autoFirstPage: false });
doc.pipe(fs.createWriteStream('Rapport_Global_Ateliers.pdf'));

// Helper to add a section
function addAtelierSection(doc, title, description, features, images) {
    doc.addPage();
    doc.fontSize(25).text(title, { align: 'center' });
    doc.moveDown();
    doc.fontSize(14).text(description, { align: 'center' });
    doc.moveDown();

    doc.fontSize(16).text('Fonctionnalités :', { underline: true });
    doc.fontSize(12).list(features);
    doc.moveDown();

    images.forEach(img => {
        if (fs.existsSync(img.path)) {
            doc.addPage();
            doc.fontSize(18).text(img.label, { align: 'center' });
            doc.moveDown();
            doc.image(img.path, { fit: [500, 400], align: 'center', valign: 'center' });
        } else {
            doc.text(`Image manquant: ${img.path}`);
        }
    });
}

// Cover Page
doc.addPage();
doc.fontSize(30).text('Rapport de Projet Flutter', { align: 'center', valign: 'center' });
doc.moveDown();
doc.fontSize(20).text('Ateliers 1 à 4', { align: 'center' });


// Atelier 1
addAtelierSection(doc,
    'Atelier 1: Gestion de Produits Basique',
    'Affichage d\'une liste statique et formulaire d\'ajout basique.',
    [
        'Liste des produits avec Card et ListTile.',
        'Suppression d\'un élément (sans Undo).',
        'Formulaire d\'ajout non validé.',
    ],
    [
        { label: 'Ecran d\'accueil', path: 'global_docs/atelier1_home.png' },
        { label: 'Ecran d\'ajout', path: 'global_docs/atelier1_add.png' }
    ]
);

// Atelier 2
addAtelierSection(doc,
    'Atelier 2: Validation & UX',
    'Validation des formulaires et amélioration de l\'expérience utilisateur.',
    [
        'Validation stricte (titre, prix, url).',
        'Prévisualisation de l\'image.',
        'SnackBar avec Undo pour la suppression.',
        'Clavier numérique pour le prix.',
    ],
    [
        { label: 'Ecran d\'accueil', path: 'global_docs/atelier2_home.png' },
        { label: 'Ecran d\'ajout (Validé)', path: 'global_docs/atelier2_add.png' }
    ]
);

// Atelier 3
addAtelierSection(doc,
    'Atelier 3: Navigation & Détails',
    'Navigation avancée avec Drawer et routes nommées.',
    [
        'Menu latéral (Drawer).',
        'Navigation vers les détails du produit.',
        'Gestion des routes dans main.dart.',
    ],
    [
        { label: 'Ecran d\'accueil', path: 'global_docs/atelier3_home.png' },
        { label: 'Menu Lateral (Drawer)', path: 'global_docs/atelier3_drawer.png' },
        { label: 'Détails du Produit', path: 'global_docs/atelier3_detail.png' }
    ]
);

// Placeholder for 4.1 & 4.2 (will be populated as we get screenshots)
// ...

doc.end();
