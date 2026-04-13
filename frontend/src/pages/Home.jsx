import React, { useEffect, useState } from 'react';
import api from '../api/axios';
import { Link } from 'react-router-dom';

const MovieCard = ({ m }) => (
    <Link to={`/movie/${m.id}`} className="group relative block rounded-lg overflow-hidden border border-slate-700 hover:border-cine-gold transition-all duration-300">
        <div className="aspect-[2/3] bg-slate-800">
            {m.poster_url ? <img src={m.poster_url} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" /> : null}
        </div>
        <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/40 to-transparent p-4 flex flex-col justify-end">
            <h3 className="font-bold text-white text-lg truncate group-hover:text-cine-gold transition-colors">{m.title}</h3>
            <div className="flex justify-between text-sm mt-1">
                <span className="text-slate-300">{new Date(m.release_date).getFullYear()}</span>
                <span className="text-cine-gold font-bold flex items-center gap-1">★ {m.aggregate_rating}</span>
            </div>
        </div>
    </Link>
);

export const Home = () => {
    const [movies, setMovies] = useState([]);

    useEffect(() => {
        api.get('/movies').then(res => setMovies(res.data.slice(0, 10))).catch(() => {});
    }, []);

    return (
        <div className="space-y-12 pb-12">
            <section className="relative h-[60vh] rounded-2xl overflow-hidden shadow-2xl border border-slate-700">
                <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=2000&auto=format&fit=crop')] bg-cover bg-center" />
                <div className="absolute inset-0 bg-gradient-to-r from-cine-darker/90 via-cine-darker/60 to-transparent" />
                <div className="absolute bottom-12 left-12 max-w-2xl">
                    <span className="px-3 py-1 bg-cine-gold text-slate-900 font-bold text-sm tracking-wider rounded uppercase">Featured</span>
                    <h1 className="text-5xl md:text-6xl font-bold mt-4 text-white">Discover the Best of Cinema</h1>
                    <p className="mt-4 text-lg text-slate-300">Your ultimate destination for Bollywood and South Indian movies, honest reviews, and theatre showtimes.</p>
                    <Link to="/browse" className="inline-block mt-8 px-8 py-3 bg-cine-gold text-slate-900 font-bold rounded-lg hover:bg-yellow-500 transition-colors shadow-lg shadow-cine-gold/20">Explore Movies</Link>
                </div>
            </section>

            <section>
                <h2 className="text-2xl font-bold text-white mb-6 border-l-4 border-cine-gold pl-3">Trending Movies</h2>
                <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-6">
                    {movies.map(m => <MovieCard key={m.id} m={m} />)}
                    {movies.length === 0 && Array(5).fill(0).map((_, i) => <div key={i} className="aspect-[2/3] bg-slate-800 rounded-lg animate-pulse" />)}
                </div>
            </section>
        </div>
    );
};

export const Browse = () => {
    const [movies, setMovies] = useState([]);
    const [search, setSearch] = useState('');

    useEffect(() => {
        const fetchUrl = search ? `/movies/search?q=${search}` : '/movies';
        api.get(fetchUrl).then(res => setMovies(res.data)).catch(() => {});
    }, [search]);

    return (
        <div className="pb-12 space-y-6">
            <div className="glass-panel p-6 flex flex-col md:flex-row gap-4 items-center justify-between">
                <h1 className="text-3xl font-bold text-white">Browse Library</h1>
                <input 
                    type="text" 
                    placeholder="Search movies by title or plot..." 
                    className="w-full md:w-96 bg-slate-800 border border-slate-600 focus:border-cine-gold rounded p-3 outline-none"
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                />
            </div>
            
            <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-6">
                {movies.map(m => <MovieCard key={m.id} m={m} />)}
            </div>
        </div>
    );
};
