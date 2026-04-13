import React from 'react';
import { useAuth } from '../context/AuthContext';
import { Link } from 'react-router-dom';
import { FileVideo, UserCircle } from 'lucide-react';

const Navbar = ({ onOpenAuth }) => {
    const { user, logout, isAdmin } = useAuth();

    return (
        <nav className="glass-panel sticky top-0 z-50 flex items-center justify-between px-6 py-4 mb-8">
            <Link to="/" className="flex items-center gap-2 text-cine-gold font-bold text-2xl tracking-tight">
                <FileVideo className="h-8 w-8" />
                <span>CineVault</span>
            </Link>
            <div className="flex gap-6 items-center">
                <Link to="/browse" className="hover:text-cine-gold transition-colors">Browse</Link>
                <Link to="/showtimes" className="hover:text-cine-gold transition-colors">Showtimes</Link>
                <Link to="/watchlist" className="hover:text-cine-gold transition-colors">Watchlist</Link>
                
                {user ? (
                    <div className="relative group ml-4">
                        <button className="flex items-center gap-2 hover:text-cine-gold focus:outline-none">
                            <UserCircle className="h-7 w-7 text-cine-gold" />
                            <span>{user.displayName || user.username}</span>
                        </button>
                        <div className="absolute right-0 mt-2 w-48 bg-cine-panel border border-slate-700 rounded-md shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                            <div className="p-2 flex flex-col gap-1">
                                <Link to="/profile" className="px-3 py-2 hover:bg-slate-700/50 rounded-md block">Profile</Link>
                                {isAdmin && <Link to="/admin" className="px-3 py-2 hover:bg-slate-700/50 rounded-md block text-rose-400">Admin Panel</Link>}
                                <button onClick={logout} className="px-3 py-2 hover:bg-slate-700/50 rounded-md text-left text-slate-400">Logout</button>
                            </div>
                        </div>
                    </div>
                ) : (
                    <button onClick={onOpenAuth} className="px-5 py-2 bg-cine-gold text-slate-900 font-semibold rounded-md hover:bg-yellow-500 transition-colors">
                        Sign In
                    </button>
                )}
            </div>
        </nav>
    );
};

export default Navbar;
